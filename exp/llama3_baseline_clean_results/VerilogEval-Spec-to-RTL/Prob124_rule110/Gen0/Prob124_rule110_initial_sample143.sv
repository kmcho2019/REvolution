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
        // Handle boundary conditions
        q[0] <= (load) ? data[0] : 
            (q[511] == 1'b1 && q[0] == 1'b1) ? 1'b1 : 
            (q[511] == 1'b1 && q[0] == 1'b0) ? 1'b1 : 
            (q[511] == 1'b0 && q[0] == 1'b1) ? 1'b1 : 
            (q[511] == 1'b0 && q[0] == 1'b0) ? 1'b0 : 
            (q[0] == 1'b1 && q[1] == 1'b1) ? 1'b1 : 
            (q[0] == 1'b1 && q[1] == 1'b0) ? 1'b1 : 
            (q[0] == 1'b0 && q[1] == 1'b1) ? 1'b1 : 
            (q[0] == 1'b0 && q[1] == 1'b0) ? 1'b0 : 1'b0;
        q[511] <= (load) ? data[511] : 
            (q[510] == 1'b1 && q[511] == 1'b1) ? 1'b1 : 
            (q[510] == 1'b1 && q[511] == 1'b0) ? 1'b1 : 
            (q[510] == 1'b0 && q[511] == 1'b1) ? 1'b1 : 
            (q[510] == 1'b0 && q[511] == 1'b0) ? 1'b0 : 
            (q[511] == 1'b1 && q[510] == 1'b1) ? 1'b1 : 
            (q[511] == 1'b1 && q[510] == 1'b0) ? 1'b1 : 
            (q[511] == 1'b0 && q[510] == 1'b1) ? 1'b1 : 
            (q[511] == 1'b0 && q[510] == 1'b0) ? 1'b0 : 1'b0;
    end
end

endmodule