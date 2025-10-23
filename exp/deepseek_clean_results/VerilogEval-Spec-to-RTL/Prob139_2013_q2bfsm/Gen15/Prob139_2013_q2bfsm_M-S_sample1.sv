module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [2:0] x_shift;
reg [1:0] y_timeout;

localparam IDLE = 2'b00;
localparam PULSE_F = 2'b01;
localparam ACTIVE = 2'b10;

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_timeout <= 0;
    end else begin
        case (state)
            IDLE: begin
                state <= PULSE_F;
                f <= 0;
            end
            
            PULSE_F: begin
                state <= ACTIVE;
                f <= 1;
            end
            
            ACTIVE: begin
                f <= 0;
                x_shift <= {x_shift[1:0], x};
                
                // Check for pattern match
                if (x_shift == 3'b101 && !g) begin
                    g <= 1;
                    y_timeout <= 0;
                end
                
                // Handle y monitoring when g=1
                if (g) begin
                    if (y) begin
                        // Keep g=1 permanently
                        y_timeout <= 0;
                    end else if (y_timeout < 2) begin
                        y_timeout <= y_timeout + 1;
                    end else begin
                        g <= 0; // Timeout reached
                    end
                end
            end
        endcase
    end
end

endmodule