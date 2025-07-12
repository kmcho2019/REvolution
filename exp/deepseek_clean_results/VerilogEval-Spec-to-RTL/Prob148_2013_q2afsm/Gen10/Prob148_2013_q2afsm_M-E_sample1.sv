module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] current_holder; // 00: none, 01: device0, 10: device1, 11: device2

    // Priority-based grant selection
    wire [1:0] next_holder = 
        (current_holder != 0 && r[current_holder-1]) ? current_holder : // Keep current if still requesting
        (r[0] ? 2'b01 : // Highest priority
         r[1] ? 2'b10 : 
         r[2] ? 2'b11 : 
         2'b00);

    // State maintenance
    always @(posedge clk) begin
        if (!resetn) current_holder <= 2'b00;
        else current_holder <= next_holder;
    end

    // Output assignment
    assign g = (current_holder == 2'b01) ? 3'b001 :
               (current_holder == 2'b10) ? 3'b010 :
               (current_holder == 2'b11) ? 3'b100 :
               3'b000;

endmodule