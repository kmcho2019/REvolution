module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State encoding
    localparam IDLE = 0;
    localparam LOAD = 1;
    localparam SHIFT = 2;
    localparam MASK = 3;
    localparam ACCUM = 4;
    localparam FINISH = 5;

    reg [2:0] state;
    reg [4:0] cycle;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] shifted [0:15];
    reg [15:0] mask;
    wire [31:0] partial_sum [0:15];

    // Parallel shift generation
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted[i] = {16'b0, breg} << i;
        end
    endgenerate

    // Mask generation
    always @(*) begin
        mask = 16'b0;
        if (state == MASK) begin
            mask = areg & (16'b1 << cycle);
        end
    end

    // Parallel prefix adder tree
    assign partial_sum[0] = mask[0] ? shifted[0] : 32'b0;
    generate
        for (i = 1; i < 16; i = i + 1) begin : adder_tree
            assign partial_sum[i] = partial_sum[i-1] + (mask[i] ? shifted[i] : 32'b0);
        end
    endgenerate

    // Control FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cycle <= 5'd0;
            areg <= 16'b0;
            breg <= 16'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= LOAD;
                        cycle <= 5'd0;
                    end
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    state <= SHIFT;
                    cycle <= cycle + 1;
                end
                
                SHIFT: begin
                    if (cycle == 5) begin
                        state <= MASK;
                        cycle <= 5'd0;
                    end else begin
                        cycle <= cycle + 1;
                    end
                end
                
                MASK: begin
                    state <= ACCUM;
                end
                
                ACCUM: begin
                    yout <= partial_sum[15];
                    state <= FINISH;
                end
                
                FINISH: begin
                    done <= 1'b1;
                    if (!start) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule