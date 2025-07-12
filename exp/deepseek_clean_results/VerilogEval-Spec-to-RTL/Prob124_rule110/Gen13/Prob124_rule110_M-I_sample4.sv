module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [513:0] extended_q;  // q[-1] to q[512] for boundary handling

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Handle boundary conditions
            extended_q[512:1] <= q;
            extended_q[0] <= 1'b0;      // q[-1]
            extended_q[513] <= 1'b0;    // q[512]

            // Compute next state
            for (integer i = 0; i < 512; i = i + 1) begin
                case ({extended_q[i+2], extended_q[i+1], extended_q[i]})
                    3'b111: q[i] <= 1'b0;
                    3'b110: q[i] <= 1'b1;
                    3'b101: q[i] <= 1'b1;
                    3'b100: q[i] <= 1'b0;
                    3'b011: q[i] <= 1'b1;
                    3'b010: q[i] <= 1'b1;
                    3'b001: q[i] <= 1'b1;
                    3'b000: q[i] <= 1'b0;
                endcase
            end
        end
    end

endmodule