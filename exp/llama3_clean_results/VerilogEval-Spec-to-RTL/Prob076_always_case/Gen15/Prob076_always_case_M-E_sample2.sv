module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

reg [3:0] selected_data;

always @(sel or data0 or data1 or data2 or data3 or data4 or data5) begin
    case (sel)
        3'b000: selected_data = data0;
        3'b001: selected_data = data1;
        3'b010: selected_data = data2;
        3'b011: selected_data = data3;
        3'b100: selected_data = data4;
        3'b101: selected_data = data5;
        default: selected_data = 4'b0000;
    endcase
    
    if (sel >= 3'b110) begin
        out = 4'b0000;
    end else begin
        out = selected_data;
    end
end

endmodule