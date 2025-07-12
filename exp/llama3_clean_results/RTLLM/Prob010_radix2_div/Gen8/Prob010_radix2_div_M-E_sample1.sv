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
reg [1:0] state; // State machine state
reg start; // Start signal
reg load; // Load signal
reg shift; // Shift signal
reg subtract; // Subtract signal

// Datapath signals
reg [15:0] dividend_reg; // Dividend register
reg [7:0] divisor_reg; // Divisor register
reg [7:0] quotient_reg; // Quotient register
reg [7:0] remainder_reg; // Remainder register

// Controller
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 2'b00; // Idle state
        start <= 0;
        load <= 0;
        shift <= 0;
        subtract <= 0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (opn_valid) begin
                    start <= 1;
                    load <= 1;
                    state <= 2'b01; // Start state
                end
            end
            2'b01: begin // Start state
                if (load) begin
                    load <= 0;
                    shift <= 1;
                    state <= 2'b10; // Division state
                end
            end
            2'b10: begin // Division state
                if (shift) begin
                    shift <= 0;
                    subtract <= 1;
                    if (dividend_reg[15]) begin
                        state <= 2'b11; // Result ready state
                    end else begin
                        state <= 2'b10; // Division state
                    end
                end
            end
            2'b11: begin // Result ready state
                res_valid <= 1;
                if (!opn_valid) begin
                    res_valid <= 0;
                    state <= 2'b00; // Idle state
                end
            end
        endcase
    end
end

// Datapath
always @(posedge clk) begin
    if (load) begin
        dividend_reg <= {8'b0, dividend};
        divisor_reg <= divisor;
    end
    if (shift) begin
        dividend_reg <= {dividend_reg[14:0], 1'b0};
    end
    if (subtract) begin
        if (dividend_reg[15]) begin
            remainder_reg <= dividend_reg[7:0] - divisor_reg;
        end else begin
            remainder_reg <= dividend_reg[7:0];
        end
        quotient_reg <= quotient_reg + 1;
    end
end

assign result = {remainder_reg, quotient_reg};
assign res_valid = (state == 2'b11);

endmodule