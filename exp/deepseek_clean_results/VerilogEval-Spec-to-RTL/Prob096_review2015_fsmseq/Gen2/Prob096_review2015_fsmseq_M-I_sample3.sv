module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding (2 bits for 5 states)
    localparam IDLE   = 2'b00;
    localparam GOT1   = 2'b01;
    localparam GOT11  = 2'b10;
    localparam GOT110 = 2'b11;
    localparam FOUND  = 2'b00;  // Same as IDLE but handled specially

    reg [1:0] state;
    reg found_flag;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found_flag <= 1'b0;
            start_shifting <= 1'b0;
        end else begin
            if (found_flag) begin
                start_shifting <= 1'b1;
            end else begin
                case (state)
                    IDLE:   state <= data ? GOT1 : IDLE;
                    GOT1:   state <= data ? GOT11 : IDLE;
                    GOT11:  state <= data ? GOT11 : GOT110;
                    GOT110: begin
                        state <= data ? FOUND : IDLE;
                        found_flag <= data ? 1'b1 : 1'b0;
                    end
                endcase
            end
        end
    end

endmodule