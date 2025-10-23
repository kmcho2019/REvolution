module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP  = 4'b0100;
    localparam WAIT  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next state logic
    assign next_state = 
        (state == IDLE && in == 0) ? RECEIVE :
        (state == RECEIVE && bit_count == 3'd7) ? STOP :
        (state == STOP && in == 1) ? IDLE :
        (state == STOP && in == 0) ? WAIT :
        (state == WAIT && in == 1) ? IDLE :
        state;

    // Bit counter
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'b0;
        end else begin
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
        end
    end

    // Shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            shift_reg <= {in, shift_reg[7:1]}; // LSB first
        end
    end

    // Done signal
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            done <= (state == STOP && in == 1);
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

endmodule