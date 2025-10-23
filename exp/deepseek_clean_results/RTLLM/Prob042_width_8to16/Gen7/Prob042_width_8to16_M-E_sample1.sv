module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Gray-coded state definition
localparam [1:0] IDLE  = 2'b00;
localparam [1:0] FIRST = 2'b01;
localparam [1:0] SECOND = 2'b11;

reg [1:0] state, next_state;
reg [7:0] buffer [0:1];  // Ping-pong buffers
reg buffer_sel;          // Buffer selection flag
reg output_ready;        // Output ready flag

// Gray code state transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        buffer_sel <= 1'b0;
        output_ready <= 1'b0;
    end else begin
        state <= next_state;
        if (valid_in && (state == FIRST))
            buffer_sel <= ~buffer_sel;
        if (state == SECOND)
            output_ready <= 1'b1;
        else
            output_ready <= 1'b0;
    end
end

// State machine and buffer management
always @(*) begin
    next_state = state;
    case (state)
        IDLE: if (valid_in) next_state = FIRST;
        FIRST: if (valid_in) next_state = SECOND;
        SECOND: next_state = IDLE;
    endcase
end

// Data capture pipeline
always @(posedge clk) begin
    if (valid_in) begin
        if (state == IDLE || state == SECOND)
            buffer[0] <= data_in;
        else if (state == FIRST)
            buffer[1] <= data_in;
    end
end

// Output generation with early valid prediction
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= output_ready;
        if (output_ready) begin
            if (buffer_sel)
                data_out <= {buffer[1], buffer[0]};
            else
                data_out <= {buffer[0], buffer[1]};
        end
    end
end

endmodule