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
reg [1:0] cycle_count;

localparam RESET     = 2'b00;
localparam PULSE_F   = 2'b01;
localparam MONITOR_X = 2'b10;
localparam FINAL     = 2'b11;

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        cycle_count <= 0;
    end else begin
        case (state)
            RESET: begin
                state <= PULSE_F;
            end
            
            PULSE_F: begin
                f <= 1;
                state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                f <= 0;
                x_shift <= {x_shift[1:0], x};
                
                if (x_shift == 3'b101) begin
                    state <= FINAL;
                    cycle_count <= 0;
                end
            end
            
            FINAL: begin
                if (cycle_count < 2) begin
                    cycle_count <= cycle_count + 1;
                    if (y) begin
                        g <= 1;
                        cycle_count <= 2; // Lock g=1 permanently
                    end else if (cycle_count == 1) begin
                        g <= 0; // Lock g=0 permanently
                    end
                end
            end
        endcase
    end
end

endmodule