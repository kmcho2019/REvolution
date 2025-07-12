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

    // Combinational 6-to-1 multiplexer
    always @(*) begin
        case (sel)
            3'd0: out = data0; // Select data0 when sel is 0
            3'd1: out = data1; // Select data1 when sel is 1
            3'd2: out = data2; // Select data2 when sel is 2
            3'd3: out = data3; // Select data3 when sel is 3
            3'd4: out = data4; // Select data4 when sel is 4
            3'd5: out = data5; // Select data5 when sel is 5
            default: out = 4'b0000; // Output zero for sel values 6 or 7
        endcase
    end

endmodule