module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] state;
    reg found;
    
    localparam IDLE = 2'b00;
    localparam S1   = 2'b01;
    localparam S11  = 2'b10;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found <= 1'b0;
        end else if (!found) begin
            case (state)
                IDLE: state <= data ? S1 : IDLE;
                S1:   state <= data ? S11 : IDLE;
                S11:  begin
                    if (!data) state <= IDLE;
                    found <= data;
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign start_shifting = found;

endmodule