module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary encoding for states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state logic - combinational
    always @(*) begin
        if(state == IDLE) begin
            if(in == 1'b0) 
                next_state = RECEIVE;
            else 
                next_state = IDLE;
        end else if(state == RECEIVE) begin
            if(bit_count == 3'd7)
                next_state = STOP;
            else
                next_state = RECEIVE;
        end else if(state == STOP) begin
            if(in == 1'b1)
                next_state = IDLE;
            else
                next_state = ERROR;
        end else /* state == ERROR */ begin
            if(in == 1'b1)
                next_state = IDLE;
            else
                next_state = ERROR;
        end
    end

    // Done signal combinational logic
    wire done_next = (state == STOP) && (in == 1'b1);

    // Sequential logic - state, bit_count, data_reg, done
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_next;

            if(state == IDLE) begin
                bit_count <= 3'd0;
                data_reg <= 8'd0;
            end else if(state == RECEIVE) begin
                // Shift in serial bit LSB first
                data_reg <= {in, data_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end
            // In STOP and ERROR states, hold bit_count and data_reg
        end
    end

endmodule