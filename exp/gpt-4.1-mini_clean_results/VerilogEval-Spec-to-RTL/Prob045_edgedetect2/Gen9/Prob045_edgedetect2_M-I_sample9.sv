module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    wire update_en;

    assign update_en = |(in ^ in_dly); // Enable update only when input changes

    always @(posedge clk) begin
        if (update_en) begin
            anyedge <= in ^ in_dly;
            in_dly <= in;
        end else begin
            anyedge <= 8'b0;  // Clear output if no change detected
        end
    end
endmodule