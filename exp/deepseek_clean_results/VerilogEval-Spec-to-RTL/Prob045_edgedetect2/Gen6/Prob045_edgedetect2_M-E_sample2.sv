module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // State encoding for each bit's FSM
    localparam IDLE    = 2'b00;
    localparam RISING  = 2'b01;
    localparam FALLING = 2'b10;

    reg [1:0] state [7:0];
    reg [7:0] prev_in;

    integer i;
    always @(posedge clk) begin
        prev_in <= in;
        
        for (i = 0; i < 8; i = i + 1) begin
            case (state[i])
                IDLE: begin
                    if (prev_in[i] && !in[i]) begin
                        state[i] <= FALLING;
                        anyedge[i] <= 1'b1;
                    end
                    else if (!prev_in[i] && in[i]) begin
                        state[i] <= RISING;
                        anyedge[i] <= 1'b1;
                    end
                    else begin
                        anyedge[i] <= 1'b0;
                    end
                end
                
                RISING, FALLING: begin
                    state[i] <= IDLE;
                    anyedge[i] <= 1'b0;
                end
                
                default: state[i] <= IDLE;
            endcase
        end
    end

    // Initialize all FSMs to IDLE state
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            state[i] = IDLE;
            anyedge[i] = 1'b0;
        end
    end

endmodule