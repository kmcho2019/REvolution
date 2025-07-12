module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] current_in;
    reg [WIDTH-1:0] prev_in;
    reg [WIDTH-1:0] next_pedge;
    reg in_changed;
    
    always @(posedge clk) begin
        in_changed <= (in != current_in);
        if (in_changed) begin
            prev_in <= current_in;
            current_in <= in;
        end
        
        pedge <= next_pedge;
    end
    
    // Detect 0->1 transition (prev_in was 0 and current_in is 1)
    always @(*) begin
        next_pedge = ~prev_in & current_in;
    end

endmodule