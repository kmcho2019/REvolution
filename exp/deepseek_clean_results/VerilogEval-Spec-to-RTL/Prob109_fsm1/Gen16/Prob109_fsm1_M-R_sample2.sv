module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions with localparam for better readability
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    
    reg state;
    
    // State register update with direct transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_A: state <= in ? STATE_A : STATE_B;
                STATE_B: state <= in ? STATE_B : STATE_A;
                default: state <= STATE_B;
            endcase
        end
    end
    
    // Output assignment remains simple
    assign out = (state == STATE_B);
    
endmodule