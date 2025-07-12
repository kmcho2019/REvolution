module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] curr_in;
    
    always @(posedge clk) begin
        // Store previous and current input values
        prev_in <= curr_in;
        curr_in <= in;
        
        // Detect positive edges synchronously
        pedge <= ~prev_in & curr_in;
    end

endmodule