module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg gated_clk;
    reg [7:0] stable_count;
    
    // Clock gating when input is stable for 2 cycles
    always @(posedge clk) begin
        if (in == prev_in) begin
            stable_count <= stable_count + 1;
            gated_clk <= (stable_count >= 2) ? 1'b0 : 1'b1;
        end else begin
            stable_count <= 0;
            gated_clk <= 1'b1;
        end
    end
    
    // Edge detection with gated clock
    always @(posedge gated_clk) begin
        pedge <= ~prev_in & in;
        prev_in <= in;
    end

endmodule