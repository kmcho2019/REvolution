module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // Control signals
    reg [4:0] count;
    wire count_en = start && (count < 17);
    wire count_rst = !rst_n || (!start && count == 0);
    wire op_done = (count == 17);

    // Datapath control
    wire shift_load = (count == 0);
    wire shift_en = (count > 0) && (count < 17);

    // Datapath registers
    reg [15:0] areg;
    reg [31:0] acc;
    reg [15:0] breg;  // Reduced from 32 bits for power savings
    
    // Counter logic (optimized from Example 1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else if (count_rst) begin
            count <= 5'd0;
        end else if (count_en) begin
            count <= count + 1;
        end
    end

    // Datapath logic (combined best of both)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
            breg <= 16'b0;
        end else if (start) begin
            if (shift_load) begin
                areg <= ain;
                acc <= 32'b0;
                breg <= bin;
            end else if (shift_en) begin
                if (areg[count-1]) begin
                    acc <= acc + {16'b0, breg} << (count-1);
                end
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = op_done;

endmodule