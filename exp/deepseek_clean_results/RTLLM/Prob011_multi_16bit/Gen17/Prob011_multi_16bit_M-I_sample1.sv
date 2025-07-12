module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam LOAD  = 4'b0010;
    localparam SHIFT = 4'b0100;
    localparam ACCUM = 4'b1000;

    reg [3:0] state;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    reg [3:0] count;
    reg [15:0] shift_mask;
    reg done_reg;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= start ? LOAD : IDLE;
                LOAD:  state <= SHIFT;
                SHIFT: state <= ACCUM;
                ACCUM: begin
                    if (count == 15) state <= IDLE;
                    else state <= SHIFT;
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
            shift_mask <= 16'b1;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    breg <= 16'b0;
                    acc <= 32'b0;
                    count <= 4'b0;
                    shift_mask <= 16'b1;
                    done_reg <= 1'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    count <= 4'b0;
                    shift_mask <= 16'b1;
                end
                SHIFT: begin
                    // Prepare shifted value for next cycle
                    shift_mask <= shift_mask << 1;
                end
                ACCUM: begin
                    if (areg[count]) begin
                        acc <= acc + ({16'b0, breg} << count);
                    end
                    count <= count + 1;
                    done_reg <= (count == 15);
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = done_reg;

endmodule