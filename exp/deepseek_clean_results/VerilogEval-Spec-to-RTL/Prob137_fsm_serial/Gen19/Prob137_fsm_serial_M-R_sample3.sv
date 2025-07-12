module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP  = 4'b0100;
    localparam WAIT  = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Continuous assignments for next state
    wire next_idle = (state == IDLE && in) || 
                    (state == STOP && in) || 
                    (state == WAIT && in);
    wire next_receive = (state == IDLE && !in);
    wire next_stop = (state == RECEIVE && bit_count == 3'b111);
    wire next_wait = (state == STOP && !in);

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= {next_wait, next_stop, next_receive, next_idle};
        end
    end

    // Counter logic
    assign bit_count_inc = bit_count + 1;
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 0;
        end else if (state == RECEIVE) begin
            bit_count <= bit_count_inc;
        end else begin
            bit_count <= 0;
        end
    end

    // Shift register (LSB first)
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            data_reg <= {in, data_reg[7:1]};
        end
    end

    // Done signal (combinational)
    assign done = (state == STOP) && in;

endmodule