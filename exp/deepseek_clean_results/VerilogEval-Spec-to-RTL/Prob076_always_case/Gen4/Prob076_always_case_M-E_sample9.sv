module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);

wire [3:0] lower_mux_out;
wire [3:0] upper_mux_out;

// Lower group mux (data0-2)
always @(*) begin
    case (sel[1:0])
        2'b00: lower_mux_out = data0;
        2'b01: lower_mux_out = data1;
        2'b10: lower_mux_out = data2;
        default: lower_mux_out = 4'b0000;
    endcase
end

// Upper group mux (data3-5)
always @(*) begin
    case (sel[1:0])
        2'b00: upper_mux_out = data3;
        2'b01: upper_mux_out = data4;
        2'b10: upper_mux_out = data5;
        default: upper_mux_out = 4'b0000;
    endcase
end

// Final selection
always @(*) begin
    if (sel[2] == 1'b0 && sel[1:0] < 3) begin
        out = lower_mux_out;
    end else if (sel[2] == 1'b1 && sel[1:0] < 3) begin
        out = upper_mux_out;
    end else begin
        out = 4'b0000;
    end
end

endmodule