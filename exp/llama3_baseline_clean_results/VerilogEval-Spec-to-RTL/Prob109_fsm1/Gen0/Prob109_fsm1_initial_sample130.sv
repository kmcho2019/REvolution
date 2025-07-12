module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] current_state;  // 0 for A, 1 for B
reg [0:0] next_state;

// Output logic
always @(*)
begin
    case(current_state)
        1'b0: out = 1'b0;  // State A
        1'b1: out = 1'b1;  // State B
    endcase
end

// State transition logic
always @(posedge clk or posedge areset)
begin
    if(areset)
    begin
        current_state <= 1'b1;  // Reset to state B
    end
    else
    begin
        case(current_state)
            1'b0:  // State A
            begin
                if(in)
                    next_state = 1'b0;
                else
                    next_state = 1'b1;
            end
            1'b1:  // State B
            begin
                if(in)
                    next_state = 1'b1;
                else
                    next_state = 1'b0;
            end
        endcase
        current_state <= next_state;
    end
end

endmodule