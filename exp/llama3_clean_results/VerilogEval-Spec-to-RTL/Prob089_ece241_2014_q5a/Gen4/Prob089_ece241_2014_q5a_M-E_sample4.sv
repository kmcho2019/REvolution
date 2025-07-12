module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] lfsr = 32'd0; // LFSR to store input bits
reg carry = 1'b0; // carry flag
reg [4:0] count = 5'd0; // counter for input bits
reg [1:0] state = 2'd0; // 2'd0: idle, 2'd1: calculate, 2'd2: output

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'd0;
        lfsr <= 32'd0;
        carry <= 1'b0;
        count <= 5'd0;
        z <= 1'b0;
    end else begin
        case (state)
            2'd0: begin // idle state
                if (~areset) begin
                    state <= 2'd1;
                end
            end
            2'd1: begin // calculate state
                lfsr <= {x, lfsr[31:1]}; // shift input bit into LFSR
                if (x) begin
                    carry <= 1'b1; // set carry flag
                end
                count <= count + 1'b1;
                if (areset) begin
                    state <= 2'd0;
                    lfsr <= 32'd0;
                    carry <= 1'b0;
                    count <= 5'd0;
                end else if (count == 5'd31) begin // end of input sequence
                    state <= 2'd2;
                end
            end
            2'd2: begin // output state
                if (count == 5'd0) begin
                    state <= 2'd0;
                    lfsr <= 32'd0;
                    carry <= 1'b0;
                    count <= 5'd0;
                end else begin
                    z <= ~(lfsr[0]) ^ carry; // output 2's complement
                    lfsr <= {lfsr[30:0], 1'b0}; // shift LFSR
                    count <= count - 1'b1;
                    if (lfsr[0] == 1'b1 && carry == 1'b0) begin
                        carry <= 1'b1;
                    end else if (lfsr[0] == 1'b0 && carry == 1'b1) begin
                        carry <= 1'b0;
                    end
                end
            end
        endcase
    end
end

endmodule