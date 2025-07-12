module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

// Current state
reg [1:0] curr_state;

// State transition logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        curr_state <= S0;
        z <= 0;
    end else begin
        case (curr_state)
            S0: begin
                if (x) begin
                    curr_state <= S1;
                    z <= 0;
                end else begin
                    curr_state <= S0;
                    z <= 0;
                end
            end
            S1: begin
                if (!x) begin
                    curr_state <= S2;
                    z <= 0;
                end else begin
                    curr_state <= S1;
                    z <= 0;
                end
            end
            S2: begin
                if (x) begin
                    curr_state <= S1;
                    z <= 1;
                end else begin
                    curr_state <= S0;
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule