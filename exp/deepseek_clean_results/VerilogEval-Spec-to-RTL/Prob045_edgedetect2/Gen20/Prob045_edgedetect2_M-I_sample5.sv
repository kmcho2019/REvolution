module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [1:0] stable_cnt;
    wire clk_en;
    wire [7:0] edge_detect;
    
    // Stability detection and clock gating logic
    assign edge_detect = in ^ prev_in;
    assign clk_en = (|edge_detect) || (stable_cnt != 2'b11);
    
    always @(posedge clk) begin
        if (clk_en) begin
            anyedge <= edge_detect;
            prev_in <= in;
        end
        
        // Update stability counter
        if (|edge_detect)
            stable_cnt <= 2'b00;
        else if (stable_cnt != 2'b11)
            stable_cnt <= stable_cnt + 1;
    end

endmodule