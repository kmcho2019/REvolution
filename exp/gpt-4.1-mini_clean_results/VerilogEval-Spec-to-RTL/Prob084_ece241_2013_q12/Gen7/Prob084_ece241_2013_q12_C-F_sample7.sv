module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output reg   Z
);

    reg [7:0] Q;

    // Shift register: shift right with S into Q[0] on posedge clk if enable
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Function to perform 8-to-1 mux selecting Q bit by ABC index
    function automatic bit mux8to1;
        input [7:0] data;
        input [2:0] sel;
        begin
            case (sel)
                3'b000: mux8to1 = data[0];
                3'b001: mux8to1 = data[1];
                3'b010: mux8to1 = data[2];
                3'b011: mux8to1 = data[3];
                3'b100: mux8to1 = data[4];
                3'b101: mux8to1 = data[5];
                3'b110: mux8to1 = data[6];
                3'b111: mux8to1 = data[7];
                default: mux8to1 = 1'b0; // for completeness; not reachable
            endcase
        end
    endfunction

    // Register output Z on clock to improve timing and reduce glitches
    always @(posedge clk) begin
        Z <= mux8to1(Q, {A,B,C});
    end

endmodule