module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;
    wire [1:0] next_state;

    // Next state logic as continuous assignment
    assign next_state = (state == A) ? 
                        (r[0] ? B :
                         r[1] ? C :
                         r[2] ? D :
                         A)
                       : (state == B) ? (r[0] ? B : A)
                       : (state == C) ? (r[1] ? C : A)
                       : (state == D) ? (r[2] ? D : A)
                       : A;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Registered output logic for grants
    always @(posedge clk) begin
        if (!resetn)
            g <= 3'b000;
        else begin
            case (state)
                B: g <= 3'b001;
                C: g <= 3'b010;
                D: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

endmodule