module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;
reg [9:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0;
        lfsr <= 10'd1; // initialize LFSR with a non-zero value
    end else begin
        // LFSR with a period of 1000 cycles
        lfsr <= {lfsr[8:0], lfsr[9] ^ lfsr[8] ^ lfsr[7] ^ lfsr[5]};

        // increment counter on each clock cycle
        if (lfsr == 10'd1) begin // check for LFSR reset condition
            count <= 10'd0;
        end else begin
            count <= count + 1;
        end
    end
end

assign q = count;

endmodule