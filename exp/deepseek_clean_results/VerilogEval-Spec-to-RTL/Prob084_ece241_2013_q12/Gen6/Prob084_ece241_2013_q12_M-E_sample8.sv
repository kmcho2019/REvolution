module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] memory;
    wire [2:0] select = {A, B, C};
    wire [7:0] rotated;

    // Circular rotation logic
    assign rotated = enable ? {memory[6:0], S} : 
                    {memory[7-select], memory[6:0-select]};

    always @(posedge clk) begin
        if (enable || (|select)) begin
            memory <= rotated;
        end
    end

    // Output is always the MSB after rotation
    assign Z = memory[7];
endmodule