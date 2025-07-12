module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define states
localparam S0 = 4'd0; // Initial state
localparam S1 = 4'd1; // First '1' received
localparam S2 = 4'd2; // '1' followed by '1'
localparam S3 = 4'd3; // '1' followed by '1' then '0'
localparam S4 = 4'd4; // Sequence '1101' matched

reg [3:0] current_state;
reg [3:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= S0;
        start_shifting <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == S4) start_shifting <= 1;
    end
end

always @(*) begin
    case(current_state)
        S0: begin
            if(data) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if(data) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if(!data) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if(data) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            next_state = S4; // Stay in S4 once reached
        end
        default: next_state = S0;
    endcase
end

endmodule