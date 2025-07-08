module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE    = 2'd0; // waiting for first 0
    localparam GOT_0   = 2'd1; // got initial 0, waiting for 1
    localparam GOT_01  = 2'd2; // got 0 then 1, waiting for 0 (end of pulse)

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = GOT_0;
                else
                    next_state = IDLE;
            end

            GOT_0: begin
                if (data_in == 1'b1)
                    next_state = GOT_01;
                else if (data_in == 1'b0)
                    next_state = GOT_0; // stay in GOT_0 if still zero
                else
                    next_state = IDLE; // fallback
            end

            GOT_01: begin
                if (data_in == 1'b0)
                    next_state = GOT_0; // pulse completed, go back to GOT_0 waiting for next pulse start
                else if (data_in == 1'b1)
                    next_state = GOT_01; // stay here waiting for 0
                else
                    next_state = IDLE; // fallback
            end

            default: next_state = IDLE;
        endcase
    end

    // Output and state update logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out=1 only at the cycle when we detect the falling edge from 1 to 0 in GOT_01 state
            if (state == GOT_01 && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule