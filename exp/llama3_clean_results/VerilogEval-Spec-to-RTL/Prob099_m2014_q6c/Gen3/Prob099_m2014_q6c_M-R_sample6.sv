module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

always @(*) begin
    case (1'b1)
        y[0]: begin // State A
            Y2 = w; // Transition to B on w=1, stay in A on w=0
            Y4 = 1'b0; // No direct transition to D from A
        end
        y[1]: begin // State B
            Y2 = 1'b0; // No self-loop or direct transition back to B
            Y4 = ~w; // Transition to D on w=0
        end
        y[2]: begin // State C
            Y2 = 1'b0; // No direct transition to B from C
            Y4 = ~w; // Transition to D on w=0
        end
        y[3]: begin // State D
            Y2 = w; // Transition to B on w=1
            Y4 = 1'b0; // No self-loop
        end
        y[4]: begin // State E
            Y2 = 1'b0; // No direct transition to B from E
            Y4 = 1'b0; // No self-loop or transition to D from E on w=0
        end
        y[5]: begin // State F
            Y2 = 1'b0; // No direct transition to B from F
            Y4 = 1'b0; // No direct transition to D from F on w=0
        end
        default: begin
            Y2 = 1'b0;
            Y4 = 1'b0;
        end
    endcase
end

endmodule