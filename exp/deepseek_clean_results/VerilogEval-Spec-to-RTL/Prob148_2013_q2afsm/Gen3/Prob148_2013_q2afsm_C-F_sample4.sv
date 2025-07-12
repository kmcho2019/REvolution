module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding with both styles for clarity
    parameter A = 2'b00;
    localparam B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            A: begin
                if (r[0])       next_state = B;
                else if (r[1])  next_state = C;
                else if (r[2])  next_state = D;
                else            next_state = A;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
        endcase
    end

    // State storage (sequential logic)
    always @(posedge clk) begin
        if (!resetn) current_state <= A;
        else         current_state <= next_state;
    end

    // Output logic (combinational)
    assign g = {current_state == D, 
                current_state == C, 
                current_state == B};

endmodule