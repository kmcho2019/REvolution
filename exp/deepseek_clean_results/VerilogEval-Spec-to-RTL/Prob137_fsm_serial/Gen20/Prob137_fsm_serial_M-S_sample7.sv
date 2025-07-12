module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP_WAIT  = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] data_reg;
    reg [2:0] recv_count;

    // Data shift register (LSB first)
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            data_reg <= {in, data_reg[7:1]};
        end
    end

    // State and receive counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            recv_count <= 3'b0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                recv_count <= recv_count + 1;
            end else begin
                recv_count <= 3'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : RECEIVE;
            end
            
            RECEIVE: begin
                next_state = (recv_count == 3'b111) ? STOP_WAIT : RECEIVE;
            end
            
            STOP_WAIT: begin
                next_state = in ? IDLE : STOP_WAIT;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign done = (state == STOP_WAIT) && in;

endmodule