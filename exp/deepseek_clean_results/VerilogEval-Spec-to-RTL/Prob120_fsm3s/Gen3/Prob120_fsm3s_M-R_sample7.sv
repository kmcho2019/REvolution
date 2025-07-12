module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding using localparam
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] state;

    // Next state and output logic using continuous assignments
    wire [1:0] next_state = 
        (state == A) ? (in ? B : A) :
        (state == B) ? (in ? B : C) :
        (state == C) ? (in ? D : A) :
                       (in ? B : C);  // state == D

    assign out = (state == D);

    // State update with synchronous reset
    always @(posedge clk) begin
        state <= reset ? A : next_state;
    end

endmodule