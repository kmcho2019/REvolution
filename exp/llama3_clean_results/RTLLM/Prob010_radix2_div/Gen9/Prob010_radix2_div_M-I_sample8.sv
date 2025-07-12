module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

// Controller signals
reg [2:0] state; // State machine state
reg start; // Start signal
reg load; // Load signal
reg shift; // Shift signal
reg subtract; // Subtract signal
reg [7:0] cnt; // Counter

// Datapath signals
reg [15:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated divisor
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder

// Controller
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b000; // Idle state
        start <= 0;
        load <= 0;
        shift <= 0;
        subtract <= 0;
        cnt <= 0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (opn_valid) begin
                    start <= 1;
                    load <= 1;
                    state <= 3'b001; // Start state
                end
            end
            3'b001: begin // Start state
                if (load) begin
                    load <= 0;
                    shift <= 1;
                    state <= 3'b010; // Division state
                    cnt <= 1;
                end
            end
            3'b010: begin // Division state
                if (cnt == 8) begin
                    state <= 3'b011; // Result ready state
                end else begin
                    cnt <= cnt + 1;
                    shift <= 1;
                    subtract <= 1;
                end
            end
            3'b011: begin // Result ready state
                res_valid <= 1;
                if (!opn_valid) begin
                    res_valid <= 0;
                    state <= 3'b000; // Idle state
                end
            end
        endcase
    end
end

// Datapath
always @(posedge clk) begin
    if (load) begin
        if (sign) begin
            sr <= {{8{dividend[7]}}, dividend}; // Sign extend
        end else begin
            sr <= {8'b0, dividend}; // Zero extend
        end
        neg_divisor <= ~divisor + 1; // Negate divisor
        quotient <= 0;
        remainder <= 0;
    end
    if (shift) begin
        sr <= {sr[14:0], 1'b0};
    end
    if (subtract) begin
        if (sr[15] == 1) begin
            remainder <= sr[7:0] - divisor;
        end else begin
            remainder <= sr[7:0];
        end
        quotient <= quotient + 1;
    end
    if (state == 3'b011) begin
        result <= {remainder, quotient};
    end
end

assign res_valid = (state == 3'b011);

endmodule