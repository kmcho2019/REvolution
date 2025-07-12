module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // 2-bit shift registers for each input bit (0=current, 1=previous)
    reg [1:0] history [7:0];

    // Update history and detect edges
    always @(posedge clk) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            history[i] <= {in[i], history[i][1]};
        end
    end

    // Edge detection logic (01 pattern)
    assign pedge = {8{1'b0}} | 
                  ((history[0] == 2'b01) << 0) |
                  ((history[1] == 2'b01) << 1) |
                  ((history[2] == 2'b01) << 2) |
                  ((history[3] == 2'b01) << 3) |
                  ((history[4] == 2'b01) << 4) |
                  ((history[5] == 2'b01) << 5) |
                  ((history[6] == 2'b01) << 6) |
                  ((history[7] == 2'b01) << 7);

endmodule