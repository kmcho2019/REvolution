module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            case ({q[i-1], q[i], q[i+1]})
                3'b111: q[i] <= 0;
                3'b110: q[i] <= 1;
                3'b101: q[i] <= 1;
                3'b100: q[i] <= 0;
                3'b011: q[i] <= 1;
                3'b010: q[i] <= 1;
                3'b001: q[i] <= 1;
                3'b000: q[i] <= 0;
            endcase
        end
        // Handle boundary conditions
        q[0] <= (load) ? data[0] : ({q[-1], q[0], q[1]} == 3'b111) ? 0 :
                        ({q[-1], q[0], q[1]} == 3'b110) ? 1 :
                        ({q[-1], q[0], q[1]} == 3'b101) ? 1 :
                        ({q[-1], q[0], q[1]} == 3'b100) ? 0 :
                        ({q[-1], q[0], q[1]} == 3'b011) ? 1 :
                        ({q[-1], q[0], q[1]} == 3'b010) ? 1 :
                        ({q[-1], q[0], q[1]} == 3'b001) ? 1 : 0;
        q[511] <= (load) ? data[511] : ({q[510], q[511], q[512]} == 3'b111) ? 0 :
                        ({q[510], q[511], q[512]} == 3'b110) ? 1 :
                        ({q[510], q[511], q[512]} == 3'b101) ? 1 :
                        ({q[510], q[511], q[512]} == 3'b100) ? 0 :
                        ({q[510], q[511], q[512]} == 3'b011) ? 1 :
                        ({q[510], q[511], q[512]} == 3'b010) ? 1 :
                        ({q[510], q[511], q[512]} == 3'b001) ? 1 : 0;
    end
end

assign q[0] = (q[-1]) ? 0 : q[0];
assign q[511] = (q[512]) ? 0 : q[511];

endmodule