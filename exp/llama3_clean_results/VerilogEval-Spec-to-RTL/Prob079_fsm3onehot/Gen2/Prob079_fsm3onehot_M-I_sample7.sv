module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

always @(*) begin
    case (1'b1)
        state[0]: begin // State A
            next_state = in? 4'b0010 : 4'b0001; 
            out = 1'b0;
        end
        state[1]: begin // State B
            next_state = in? 4'b0010 : 4'b0100; 
            out = 1'b0;
        end
        state[2]: begin // State C
            next_state = in? 4'b1000 : 4'b0001; 
            out = 1'b0;
        end
        state[3]: begin // State D
            next_state = in? 4'b0010 : 4'b0100; 
            out = 1'b1;
        end
        default: begin
            next_state = 4'b0000; 
            out = 1'b0;
        end
    endcase
end

endmodule