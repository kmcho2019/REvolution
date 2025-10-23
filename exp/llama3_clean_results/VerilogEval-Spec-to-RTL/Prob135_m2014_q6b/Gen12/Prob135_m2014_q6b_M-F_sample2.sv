module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output reg Y1; // Declare Y1 as a reg to allow assignment within always block

    always @(*) begin
        case (y)
            3'b000: Y1 = 1'b0; // State A transitions to B on 0 and stays in A on 1
            3'b001: begin // State B transitions to C on 0 and D on 1
                if (~w) Y1 = 1'b0;
                else Y1 = 1'b1;
            end
            3'b010: begin // State C transitions to E on 0 and D on 1
                if (~w) Y1 = 1'b1;
                else Y1 = 1'b1;
            end
            3'b011: begin // State D transitions to F on 0 and A on 1
                if (~w) Y1 = 1'b1;
                else Y1 = 1'b0;
            end
            3'b100: begin // State E stays in E on 0 and transitions to D on 1
                if (~w) Y1 = 1'b1;
                else Y1 = 1'b1;
            end
            3'b101: begin // State F transitions to C on 0 and D on 1
                if (~w) Y1 = 1'b0;
                else Y1 = 1'b1;
            end
            default: Y1 = 1'bx;
        endcase
    end
endmodule