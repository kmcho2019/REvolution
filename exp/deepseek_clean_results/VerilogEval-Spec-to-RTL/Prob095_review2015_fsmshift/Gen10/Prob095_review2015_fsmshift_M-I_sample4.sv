module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg state;
    reg [1:0] cycle_count;
    
    localparam IDLE = 1'b0;
    localparam ACTIVE = 1'b1;
    
    assign shift_ena = (state == ACTIVE);
    
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            cycle_count <= 2'b00;
        end else begin
            case (state)
                ACTIVE: begin
                    if (cycle_count == 2'b11) begin
                        state <= IDLE;
                    end
                    cycle_count <= cycle_count + 1;
                end
                IDLE: begin
                    // Stay in IDLE until next reset
                end
            endcase
        end
    end

endmodule