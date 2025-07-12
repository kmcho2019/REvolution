module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                data_reg <= {in, data_reg[7:1]};  // LSB first
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
        end
    end

    // Combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: 
                if (in == 1'b0) 
                    next_state = RECEIVE;
            
            RECEIVE:
                if (bit_count[2])  // After 8 bits (count 0-7)
                    next_state = STOP_WAIT;
            
            STOP_WAIT:
                if (in == 1'b1)
                    next_state = IDLE;
        endcase
    end

    // Done signal when we get valid stop bit
    assign done = (state == STOP_WAIT) && (in == 1'b1);

endmodule