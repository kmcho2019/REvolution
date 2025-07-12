module radix2_div (
    input            clk,
    input            rst,
    input            sign,           // 1: signed, 0: unsigned
    input      [7:0] dividend,
    input      [7:0] divisor,
    input            opn_valid,
    output reg       res_valid,
    output     [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // State encoding
    localparam IDLE = 2'd0,
               RUN  = 2'd1,
               DONE = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers
    reg [16:0] SR;         // Shift Register: {remainder[8:0], quotient[7:0]} = 17 bits
    reg [7:0]  dividend_r;
    reg [7:0]  divisor_r;
    reg        dividend_neg;
    reg        divisor_neg;

    reg [7:0]  dividend_mag;
    reg [7:0]  divisor_mag;

    reg [3:0]  count;      // counts from 0 to 8

    // Wires for combinational subtraction and shifted SR
    wire [16:0] shifted_SR = {SR[15:0], 1'b0};
    wire [8:0] divisor_ext = {1'b0, divisor_mag};
    wire [8:0] remainder_part = shifted_SR[16:8];
    wire [8:0] sub_res = remainder_part - divisor_ext;
    wire borrow_sub = sub_res[8];

    // SR update after subtraction
    wire [16:0] SR_next = !borrow_sub ? 
                          {sub_res, shifted_SR[7:1], 1'b1} :
                          {remainder_part, shifted_SR[7:1], 1'b0};

    // Quotient and remainder sign correction flags
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // Raw quotient and remainder extracted from SR at end of division
    wire [7:0] raw_quotient = SR[7:0];
    wire [7:0] raw_remainder = SR[16:9];  // upper 8 bits of remainder (discard LSB remainder bit)

    // Sign-corrected final results
    wire [7:0] quotient_corr = quotient_neg ? (~raw_quotient + 8'd1) : raw_quotient;
    wire [7:0] remainder_corr = remainder_neg ? (~raw_remainder + 8'd1) : raw_remainder;

    // Output concatenation
    assign result = {remainder_corr, quotient_corr};

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if(opn_valid && divisor != 8'd0)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if(count == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                if(!opn_valid)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            SR <= 17'd0;
            dividend_r <= 8'd0;
            divisor_r <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            dividend_mag <= 8'd0;
            divisor_mag <= 8'd0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(next_state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;
                    if(opn_valid && divisor != 8'd0) begin
                        // Latch inputs and compute magnitudes for signed operation
                        dividend_r <= dividend;
                        divisor_r <= divisor;
                        if(sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            dividend_mag <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_mag <= divisor[7] ? (~divisor + 8'd1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            dividend_mag <= dividend;
                            divisor_mag <= divisor;
                        end
                        // Initialize SR with remainder=0 and quotient=dividend_mag
                        // SR = {9'd0, dividend_mag}
                        SR <= {9'd0, dividend_mag};
                    end
                end
                RUN: begin
                    // Perform one division iteration per clock cycle
                    SR <= SR_next;
                    count <= count + 1'b1;
                end
                DONE: begin
                    res_valid <= 1'b1;
                    // Keep SR and count unchanged until next opn_valid or reset
                end
            endcase
        end
    end

endmodule