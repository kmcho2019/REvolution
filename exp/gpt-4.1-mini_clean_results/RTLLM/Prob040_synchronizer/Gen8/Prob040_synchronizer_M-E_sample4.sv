module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // active-low reset clk_a domain
    input  wire        brstn,     // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // FIFO depth 2 for safe crossing
    reg [3:0] fifo_data [1:0];
    reg       write_ptr;       // toggles on write
    reg       read_ptr;        // toggles on read

    // Synchronizer registers for write pointer into clk_b domain
    reg sync_wptr_0, sync_wptr_1;

    // Detect new data event in clk_b domain
    wire new_data_available = (sync_wptr_1 != read_ptr);

    // Write pointer toggle logic (clk_a domain)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            fifo_data[0] <= 4'd0;
            fifo_data[1] <= 4'd0;
            write_ptr    <= 1'b0;
        end else if (data_en) begin
            fifo_data[write_ptr] <= data_in;
            write_ptr <= ~write_ptr; // toggle write pointer to indicate new data
        end
    end

    // Pointer synchronizer clk_a->clk_b domain (2-stage synchronizer)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_wptr_0 <= 1'b0;
            sync_wptr_1 <= 1'b0;
        end else begin
            sync_wptr_0 <= write_ptr;
            sync_wptr_1 <= sync_wptr_0;
        end
    end

    // Read pointer and output update logic in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            read_ptr <= 1'b0;
            dataout  <= 4'd0;
        end else if (new_data_available) begin
            read_ptr <= ~read_ptr; // consume new data
            dataout <= fifo_data[read_ptr]; // read corresponding data
        end else begin
            dataout <= dataout; // hold output stable
        end
    end

endmodule