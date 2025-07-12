module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
localparam IDLE  = 2'b00;
localparam GOT_0 = 2'b01;
localparam GOT_1 = 2'b10;

reg [1:0] state, next_state;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 0)
                next_state = GOT_0;
            else
                next_state = IDLE;
        end
        GOT_0: begin
            if (data_in == 1)
                next_state = GOT_1;
            else
                next_state = GOT_0;  // Stay in GOT_0 if we get another 0
        end
        GOT_1: begin
            if (data_in == 0)
                next_state = IDLE;   // Complete the sequence
            else
                next_state = IDLE;   // Reset if we don't get the final 0
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
    end else begin
        if (state == GOT_1 && data_in == 0)
            data_out <= 1;
        else
            data_out <= 0;
    end
end

endmodule