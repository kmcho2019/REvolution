module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge;

// Sequential logic to store the previous input state
always @(posedge clk) begin
    prev_in <= in;
end

// Combinatorial logic to detect any edge transition
always @(*) begin
    for (int i = 0; i < 8; i++) begin
        anyedge[i] = (in[i] !== prev_in[i]);
    end
end

endmodule