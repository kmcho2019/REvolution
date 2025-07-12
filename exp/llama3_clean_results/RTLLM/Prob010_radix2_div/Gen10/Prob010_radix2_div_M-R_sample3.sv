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

// State machine signals
reg [2:0] state;
reg [7:0] cnt;
reg [15:0] sr;
reg [7:0] quotient;
reg [7:0] remainder;

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b000;
        cnt <= 0;
        sr <= 0;
        quotient <= 0;
        remainder <= 0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (opn_valid) begin
                    if (sign) begin
                        sr <= {{8{dividend[7]}}, dividend}; // Sign extend
                    end else begin
                        sr <= {8'b0, dividend}; // Zero extend
                    end
                    state <= 3'b001; // Start state
                    cnt <= 1;
                end
            end
            3'b001: begin // Start state
                state <= 3'b010; // Division state
            end
            3'b010: begin // Division state
                if (cnt == 8) begin
                    state <= 3'b011; // Result ready state
                end else begin
                    cnt <= cnt + 1;
                    if (sr[15] == 1) begin
                        remainder <= sr[7:0] - divisor;
                    end else begin
                        remainder <= sr[7:0];
                    end
                    quotient <= quotient + 1;
                    sr <= {sr[14:0], 1'b0};
                end
            end
            3'b011: begin // Result ready state
                if (!opn_valid) begin
                    state <= 3'b000; // Idle state
                end
            end
        endcase
    end
end

// Continuous assignments
assign res_valid = (state == 3'b011);
assign result = {remainder, quotient};

endmodule