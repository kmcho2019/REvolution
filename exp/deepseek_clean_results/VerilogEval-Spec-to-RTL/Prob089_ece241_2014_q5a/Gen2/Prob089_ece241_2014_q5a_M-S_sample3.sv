module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // States
    parameter SEARCH = 1'b0;
    parameter FLIP   = 1'b1;
    
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= SEARCH;
        end else begin
            case (state)
                SEARCH: if (x) state <= FLIP;
                FLIP:   state <= FLIP;
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            SEARCH: z = x;
            FLIP:   z = ~x;
        endcase
    end

endmodule