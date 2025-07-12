module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

reg [1:0] state;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (x == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (x == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (x == 1'b1) begin
                    state <= IDLE;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Output logic
assign z = (state == S2 && x == 1'b1);

endmodule