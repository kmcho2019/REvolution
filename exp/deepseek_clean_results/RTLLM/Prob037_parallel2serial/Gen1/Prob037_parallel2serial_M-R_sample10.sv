module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data;       // Parallel data storage
    reg [1:0] state;      // State machine (0-3)
    reg load_new;         // Flag to load new data

    // State machine transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b0;
            load_new <= 1'b1;
        end else begin
            if (state == 2'b11) begin
                state <= 2'b0;
                load_new <= 1'b1;
            end else begin
                state <= state + 1'b1;
                load_new <= 1'b0;
            end
        end
    end

    // Data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 4'b0;
        end else if (load_new) begin
            data <= d;
        end
    end

    // Output assignments
    assign dout = data[3-state];  // MSB first (state 0 outputs data[3])
    assign valid_out = (state == 2'b0) ? 1'b1 : 1'b0;

endmodule