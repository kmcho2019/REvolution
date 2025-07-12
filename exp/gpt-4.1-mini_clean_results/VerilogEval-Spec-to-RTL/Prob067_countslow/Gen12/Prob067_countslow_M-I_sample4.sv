module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [3:0] gray_count;

    // Gray code sequence for decimal 0..9:
    // decimal : gray
    // 0 : 0000
    // 1 : 0001
    // 2 : 0011
    // 3 : 0010
    // 4 : 0110
    // 5 : 0111
    // 6 : 0101
    // 7 : 0100
    // 8 : 1100
    // 9 : 1101
    // then wraps to 0 (0000)

    // Next state logic for gray_count:
    // Implemented as a case statement for clarity and low toggle.

    always @(posedge clk) begin
        if (reset) begin
            gray_count <= 4'b0000;
        end else if (slowena) begin
            case (gray_count)
                4'b0000: gray_count <= 4'b0001; //0->1
                4'b0001: gray_count <= 4'b0011; //1->2
                4'b0011: gray_count <= 4'b0010; //2->3
                4'b0010: gray_count <= 4'b0110; //3->4
                4'b0110: gray_count <= 4'b0111; //4->5
                4'b0111: gray_count <= 4'b0101; //5->6
                4'b0101: gray_count <= 4'b0100; //6->7
                4'b0100: gray_count <= 4'b1100; //7->8
                4'b1100: gray_count <= 4'b1101; //8->9
                4'b1101: gray_count <= 4'b0000; //9->0
                default: gray_count <= 4'b0000; // safety reset if invalid
            endcase
        end
    end

    // Decode Gray code to binary for q output
    // There is a standard way to convert gray to binary:
    // b3 = g3
    // b2 = g3 ^ g2
    // b1 = b2 ^ g1
    // b0 = b1 ^ g0

    always @(*) begin
        q[3] = gray_count[3];
        q[2] = gray_count[3] ^ gray_count[2];
        q[1] = q[2] ^ gray_count[1];
        q[0] = q[1] ^ gray_count[0];
    end

endmodule