module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits)
    // A = 2'b00 (idle)
    // B = 2'b01 (grant device 0)
    // C = 2'b10 (grant device 1)
    // D = 2'b11 (grant device 2)
    reg [1:0] state;

    // Next state logic as combinational signals using ternary operators
    wire [1:0] next_state = (state == 2'b00) ? 
                            (r[0] ? 2'b01 : 
                             r[1] ? 2'b10 : 
                             r[2] ? 2'b11 : 2'b00) :
                            (state == 2'b01) ? (r[0] ? 2'b01 : 2'b00) :
                            (state == 2'b10) ? (r[1] ? 2'b10 : 2'b00) :
                            (state == 2'b11) ? (r[2] ? 2'b11 : 2'b00) :
                            2'b00;

    // Synchronous state update with active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // A (idle)
        else
            state <= next_state;
    end

    // Output logic derived directly from current state
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 :
               3'b000;

endmodule