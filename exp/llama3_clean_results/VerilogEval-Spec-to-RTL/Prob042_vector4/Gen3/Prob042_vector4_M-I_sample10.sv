module TopModule(
    input  clk, // Assuming a clock signal
    input  [7:0] in,
    output [31:0] out
);

    reg [7:0] in_sync;
    
    always @(posedge clk) begin
        in_sync <= in;
    end

    assign out = {{24{in_sync[7]}}, in_sync};

endmodule