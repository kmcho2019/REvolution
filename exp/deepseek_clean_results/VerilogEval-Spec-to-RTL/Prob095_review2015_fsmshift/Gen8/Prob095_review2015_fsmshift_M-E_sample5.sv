module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] state;
    reg [1:0] cycle_count;
    
    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;
    
    assign shift_ena = (state == ACTIVE);
    
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            cycle_count <= 2'b00;
        end else begin
            case (state)
                ACTIVE: begin
                    if (cycle_count == 2'b11) begin  // After 4 cycles (0-3)
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