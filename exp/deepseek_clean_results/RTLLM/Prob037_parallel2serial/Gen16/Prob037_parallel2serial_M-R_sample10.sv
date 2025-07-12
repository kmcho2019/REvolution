module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // One-hot encoded states
    reg [3:0] state;
    reg [3:0] data;

    // State definitions
    localparam S0 = 4'b0001;
    localparam S1 = 4'b0010;
    localparam S2 = 4'b0100;
    localparam S3 = 4'b1000;

    // Next state and output logic
    wire [3:0] next_state;
    assign next_state = {state[2:0], state[3]};
    
    // Data shift logic
    wire [3:0] next_data = (state == S3) ? d : {data[2:0], 1'b0};

    // Output assignments
    assign dout = data[3];
    assign valid_out = (state == S0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data <= 4'b0;
        end else begin
            state <= next_state;
            data <= next_data;
        end
    end

endmodule