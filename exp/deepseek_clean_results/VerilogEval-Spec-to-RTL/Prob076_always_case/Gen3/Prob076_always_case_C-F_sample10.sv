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

// Internal enable signal - active when sel is valid
wire enable = (sel <= 3'd5);

always @(*) begin
    if (!enable) begin
        out = 4'b0000;  // Power-optimized default
    end else begin
        case (sel)
            0: out = data0;
            1: out = data1;
            2: out = data2;
            3: out = data3;
            4: out = data4;
            5: out = data5;
            default: out = 4'b0000; // Redundant but safe
        endcase
    end
end

endmodule