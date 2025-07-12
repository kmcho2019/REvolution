module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] state;
    reg [1:0] counter;
    
    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;
    
    assign shift_ena = (state == ACTIVE);
    
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            counter <= 2'b00;
        end else begin
            case (state)
                ACTIVE: begin
                    if (counter == 2'b11) begin
                        state <= IDLE;
                    end
                    counter <= counter + 1;
                end
                IDLE: begin
                    // Stay in IDLE until next reset
                end
            endcase
        end
    end

endmodule